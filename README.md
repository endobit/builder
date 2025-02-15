# Builder

Makefile rules for building code.

## Usage

From the root of your source tree run the following:

```
go run endobit.io/builder init
```

This will create a top level `Makefile` and a `.builder` subdirectory with the
make rules.

For Go projects add the following before the `include` line.

```
RULES=go
```

