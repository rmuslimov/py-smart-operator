.PHONY: test compile clean-elc install

EMACS ?= emacs
CASK ?= cask

install:
	${CASK} install

test: clean-elc
	${CASK} exec ert-runner

compile:
	${CASK} build

clean-elc:
	rm -f py-smart-operator.elc
