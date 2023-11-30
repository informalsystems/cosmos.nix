{buildGoModule, relayer-src}:
  buildGoModule {
    name = "relayer";
    src = relayer-src;
    vendorHash = "sha256-oJSxRUKXhjpDWk0bk7Q8r0AAc7UOhEOLj+SgsZsnzsk=";
    doCheck = false;
  }
