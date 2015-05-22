SVGS_BASE = square hex colors

SVGS = $(patsubst %,%.svg,$(SVGS_BASE))
PNGS = $(patsubst %.svg,%.png,$(SVGS))
PERLS = $(patsubst %.svg,%.pl,$(SVGS))

PODS = Advent-SVG.pod
HTMLS = $(patsubst %.pod,%.html,$(PODS))

all: $(PNGS) $(HTMLS)

firefox: $(SVGS)
	mozilla-firefox $(SVGS)

$(SVGS) : %.svg: %.pl
	perl $<

$(PNGS) : %.png: %.svg
	inkscape --export-png=$@ $<

$(HTMLS) : %.html: %.pod
	pod2xhtml < $< > $@

FILES_TO_UPLOAD = $(SVGS) $(PNGS) $(PERLS) Makefile $(PODS) $(HTMLS)

upload: $(FILES_TO_UPLOAD)
	rsync --rsh=ssh -v --progress $(FILES_TO_UPLOAD) $${HOMEPAGE_SSH_PATH}/open-source/perl/advent/2006/SVG/
