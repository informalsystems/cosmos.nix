/*
  This file defines the database schema for the PostgresQL ("psql") event sink
  implementation in Tendermint. The operator must create a database and install
  this schema before using the database to index events.
 */

-- The blocks table records metadata about each block.
-- The block record does not include its events or transactions (see tx_results).
CREATE TABLE blocks (
  rowid      BIGSERIAL PRIMARY KEY,

  height     BIGINT NOT NULL,
  chain_id   VARCHAR NOT NULL,

  -- When this block header was logged into the sink, in UTC.
  created_at TIMESTAMPTZ NOT NULL,

  UNIQUE (height, chain_id)
);

-- Index blocks by height and chain, since we need to resolve block IDs when
-- indexing transaction records and transaction events.
CREATE INDEX idx_blocks_height_chain ON blocks(height, chain_id);

-- The tx_results table records metadata about transaction results.  Note that
-- the events from a transaction are stored separately.
CREATE TABLE tx_results (
  rowid BIGSERIAL PRIMARY KEY,

  -- The block to which this transaction belongs.
  block_id BIGINT NOT NULL REFERENCES blocks(rowid),
  -- The sequential index of the transaction within the block.
  index INTEGER NOT NULL,
  -- When this result record was logged into the sink, in UTC.
  created_at TIMESTAMPTZ NOT NULL,
  -- The hex-encoded hash of the transaction.
  tx_hash VARCHAR NOT NULL,
  -- The protobuf wire encoding of the TxResult message.
  tx_result BYTEA NOT NULL,

  UNIQUE (block_id, index)
);

-- The events table records events. All events (both block and transaction) are
-- associated with a block ID; transaction events also have a transaction ID.
CREATE TABLE events (
  rowid BIGSERIAL PRIMARY KEY,

  -- The block and transaction this event belongs to.
  -- If tx_id is NULL, this is a block event.
  block_id BIGINT NOT NULL REFERENCES blocks(rowid),
  tx_id    BIGINT NULL REFERENCES tx_results(rowid),

  -- The application-defined type label for the event.
  type VARCHAR NOT NULL
)

CREATE INDEX idx_blocks_height_chain ON blocks(height, chain_id);
CREATE INDEX idx_events_type ON events(type);

-- The attributes table records event attributes.
CREATE TABLE attributes (
   event_id      BIGINT NOT NULL REFERENCES events(rowid),
   key           VARCHAR NOT NULL, -- bare key
   composite_key VARCHAR NOT NULL, -- composed type.key
   value         VARCHAR NULL,

   UNIQUE (event_id, key)
);

CREATE INDEX idx_attributes_key ON attributes(key);
CREATE INDEX idx_attributes_composite_key ON attributes(composite_key);

-- A joined view of events and their attributes. Events that do not have any
-- attributes are represented as a single row with empty key and value fields.
CREATE VIEW event_attributes AS
  SELECT block_id, tx_id, attributes.event_id as event_id, type, key, composite_key, value
  FROM events LEFT JOIN attributes ON (events.rowid = attributes.event_id);

-- A joined view of all block events (those having tx_id NULL).
CREATE VIEW block_events AS
  SELECT blocks.rowid as block_id, height, chain_id, type, key, composite_key, value
  FROM blocks JOIN event_attributes ON (blocks.rowid = event_attributes.block_id)
  WHERE event_attributes.tx_id IS NULL;

-- A joined view of all transaction events.
CREATE VIEW tx_events AS
 SELECT blocks.height,
    tx_results.index,
    tx_results.rowid AS tx_id,
    event_attributes.event_id,
    blocks.chain_id,
    event_attributes.type,
    event_attributes.key,
    event_attributes.composite_key,
    event_attributes.value,
    tx_results.created_at
   FROM blocks
     JOIN tx_results ON blocks.rowid = tx_results.block_id
     JOIN event_attributes ON tx_results.rowid = event_attributes.tx_id
  WHERE event_attributes.tx_id IS NOT NULL;


CREATE MATERIALIZED VIEW chain_internal_transfers AS
SELECT
  tr.chain_id,
  tr.event_id,
  tr.value as recipient,
  ts.value as sender,
  tv.value as amount,
  tr.created_at
FROM tx_events tr
JOIN tx_events ts
  ON ts.event_id = tr.event_id AND ts.chain_id = tr.chain_id
JOIN tx_events tv
  ON ts.event_id = tv.event_id AND ts.chain_id = tv.chain_id
WHERE tr.key = 'recipient'
  AND ts.key = 'sender'
  AND tv.key = 'amount'
  AND tr.type = 'transfer'
  AND ts.type = 'transfer'
  AND tv.type = 'transfer';


CREATE MATERIALIZED VIEW cosmos_osmosis_ibc_transfers AS
  SELECT
    data.chain_id,
    data.event_id,
    cast(data.value AS json) ->> 'receiver' as recipient,
    cast(data.value AS json) ->> 'sender' as sender,
    cast(data.value AS json) ->> 'amount' || 'uatom' as amount,
    data.created_at
  FROM tx_events data
  JOIN tx_events source
    ON source.event_id = data.event_id
  JOIN tx_events destination
    ON destination.event_id = data.event_id
  WHERE (data.composite_key = 'send_packet.packet_data'
        OR data.composite_key = 'recv_packet.packet_data')
    AND ((source.composite_key = 'send_packet.packet_src_channel'
          AND source.value = 'channel-141')
        OR (source.composite_key = 'recv_packet.packet_src_channel'
          AND source.value = 'channel-0'))
    AND ((destination.composite_key = 'send_packet.packet_dst_channel'
          AND destination.value = 'channel-0')
        OR (destination.composite_key = 'recv_packet.packet_dst_channel'
          AND destination.value = 'channel-141'))
    AND data.chain_id = 'cosmoshub-4';
