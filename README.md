# Builder

Makefile rules for building code.

## Usage

Copy `builder.mk` into the root of your source tree and put the following lines
at the start of your project's `Makefile`

```
include builder.mk
```

For Go projects add the following before the `include` line.

```
RULES=go
```

The first invocation of `make` will bootstrap the rules and return, subsequent
invocations will display the rules help as the default target.
