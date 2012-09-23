NAME := gnome-desktop-programming

PDFLATEX := $(shell which pdflatex)
BUILDDIR := build
PDFTARGET := $(BUILDDIR)/$(NAME).pdf

all: $(PDFTARGET)

TEX_FILES :=
TEX_FILES += book/arrays.tex
TEX_FILES += book/commands.tex
TEX_FILES += book/datetime.tex
TEX_FILES += book/fundamentals.tex
TEX_FILES += book/garray.tex
TEX_FILES += book/gdata.tex
TEX_FILES += book/ghashtable.tex
TEX_FILES += book/glist.tex
TEX_FILES += book/gmainloop.tex
TEX_FILES += book/gnome-desktop-programming.tex
TEX_FILES += book/gqueue.tex
TEX_FILES += book/gobject.tex
TEX_FILES += book/gtree.tex
TEX_FILES += book/introduction.tex
TEX_FILES += book/oointro.tex
TEX_FILES += book/options.tex
TEX_FILES += book/preamble.tex
TEX_FILES += book/preface.tex
TEX_FILES += book/strings.tex

FIGURE_FILES :=
FIGURE_FILES += fundamentals1.c
FIGURE_FILES += dateandtime1.c

$(BUILDDIR)/%.tex: figures/%.c
	@mkdir -p $(BUILDDIR)
	@echo "  [FORMAT]   $*"
	@./scripts/formatter.py figures/$*.c $(BUILDDIR)/$*.tex

TEX_DEPS :=
TEX_DEPS += $(TEX_FILES)
TEX_DEPS += $(foreach var,$(FIGURE_FILES),$(BUILDDIR)/$(var:.c=.tex))

$(PDFTARGET): $(TEX_DEPS)
	@mkdir -p $(BUILDDIR)
	@echo "  [COPY]     styles"
	@cp -a styles/*.sty $(BUILDDIR)
	@echo "  [COPY]     tex"
	@cp -a book/*.tex $(BUILDDIR)
	@echo "  [TOC]      $(NAME)"
	@TEXINPUTS=:$(BUILDDIR) $(PDFLATEX) -halt-on-error -output-directory $(BUILDDIR) -output-format pdf $(NAME).tex >/dev/null
	@echo "  [PDFLATEX] $(NAME).pdf"
	@rm $(BUILDDIR)/$(NAME).pdf
	@TEXINPUTS=:$(BUILDDIR) $(PDFLATEX) -halt-on-error -output-directory $(BUILDDIR) -output-format pdf $(NAME).tex >/dev/null

view: $(PDFTARGET)
	evince $(PDFTARGET)

clean:
	@echo "  [CLEAN]    build"
	@rm -rf $(BUILDDIR)
