STL_TARGETS := threaded_sleeve.stl spool_holder.stl
PNG_TARGETS := assembled.png threaded_sleeve.png spool_holder.png

OPENSCAD_BIN ?= openscad

# The main .scad file must be the first item here
COMMON_DEPS := spool_holder.scad

PNG_IMGSIZE ?= 1920,1080
PNG_OPTS := --render --autocenter --imgsize=$(PNG_IMGSIZE) --viewall

all: $(STL_TARGETS) $(PNG_TARGETS)

threaded_sleeve.stl: $(COMMON_DEPS)
	$(OPENSCAD_BIN) -o $@ $< \
	    -D '$$spool_holder=false' \
	    -D '$$threaded_sleeve=true'

threaded_sleeve.png: $(COMMON_DEPS)
	$(OPENSCAD_BIN) $(PNG_OPTS) -o $@ $< \
	    -D '$$spool_holder=false' \
	    -D '$$threaded_sleeve=true'

spool_holder.stl: $(COMMON_DEPS)
	$(OPENSCAD_BIN) -o $@ $< \
	    -D '$$spool_holder=true' \
	    -D '$$threaded_sleeve=false'

spool_holder.png: $(COMMON_DEPS)
	$(OPENSCAD_BIN) $(PNG_OPTS) -o $@ $< \
	    -D '$$spool_holder=true' \
	    -D '$$threaded_sleeve=false'

assembled.png: $(COMMON_DEPS)
	$(OPENSCAD_BIN) $(PNG_OPTS) -o $@ $< \
	    -D '$$assembled=true' \
	    -D '$$spool_holder=false' \
	    -D '$$threaded_sleeve=false'

clean:
	rm *.stl || true
	rm *.png || true

.PHONY: all clean

