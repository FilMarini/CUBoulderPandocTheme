DRAW_COMMAND = /Applications/draw.io.app/Contents/MacOS/draw.io
DRAWIO_FLAGS_PDF = -x -f pdf --crop
DRAWIO_FLAGS_PNG = -x -t -f png --crop
DRAWIO_FLAGS_SVG = -x -f svg --crop
DRAWIO_FLAGS_JPG = -x -f jpg -q 100 --crop
dirs = .
files := $(foreach dir,$(dirs),$(wildcard $(dir)/*.drawio))
PDF = $(patsubst %.drawio,%.pdf, $(files))
PNG = $(patsubst %.drawio,%.png, $(files))
SVG = $(patsubst %.drawio,%.svg, $(files))
JPG = $(patsubst %.drawio,%.jpg, $(files))

pdf: $(PDF)
all: $(PDF) $(PNG) $(SVG) $(JPG)
clean:
	@echo $(files)
	rm  -f $(patsubst %.drawio,%.pdf, $(files))
	rm  -f $(patsubst %.drawio,%.png, $(files))
	rm  -f $(patsubst %.drawio,%.svg, $(files))
	rm  -f $(patsubst %.drawio,%.jpg, $(files))

%.pdf: %.drawio
	$(DRAW_COMMAND) $(DRAWIO_FLAGS_PDF) $<

%.png: %.drawio
	$(DRAW_COMMAND) $(DRAWIO_FLAGS_PNG) $<
        
%.svg: %.drawio
	$(DRAW_COMMAND) $(DRAWIO_FLAGS_SVG) $<

%.jpg: %.drawio
	$(DRAW_COMMAND) $(DRAWIO_FLAGS_JPG) $<
