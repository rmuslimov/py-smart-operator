.PHONY: test compile clean-elc install

EMACS ?= emacs
CASK ?= cask

install:
	${CASK} install

test:
	${CASK} exec ert-runner

compile:
	${CASK} build

clean-elc:
	rm -f py-smart-operator.elc
