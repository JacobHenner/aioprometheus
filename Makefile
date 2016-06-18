# This makefile has been created to help developers perform common actions.

.PHONY: help clean clean.scrub test test.verbose coverage style style.fix
.PHONY: docs

# Do not remove this block. It is used by the 'help' rule when
# constructing the help output.
# help:
# help: aioprometheus Makefile help
# help:

STYLE_EXCLUDE_LIST:=git status --porcelain --ignored | grep "!!" | grep ".py$$" | cut -d " " -f2 | tr "\n" ","
STYLE_MAX_LINE_LENGTH:=160
STYLE_PEP8_CMD:=pep8 --exclude=.git,docs,$(shell $(STYLE_EXCLUDE_LIST)) --ignore=E309,E402 --max-line-length=$(STYLE_MAX_LINE_LENGTH) aioprometheus tests examples


# help: help                           - display this makefile's help information
help:
	@grep "^# help\:" Makefile | grep -v grep | sed 's/\# help\: //' | sed 's/\# help\://'


# help: clean                          - clean all files using .gitignore rules
clean:
	@git clean -X -f -d


# help: clean.scrub                    - clean all files, even untracked files
clean.scrub:
	git clean -x -f -d


# help: test                           - run tests
test:
	@python -m unittest discover -s tests


# help: test.verbose                   - run tests [verbosely]
test.verbose:
	@python -m unittest discover -s tests -v


# help: coverage                       - perform test coverage checks
coverage:
	@coverage run -m unittest discover -s tests
	@# produce html coverage report on modules
	@coverage html -d docs/coverage --include="aioprometheus/*"
	@# rename coverage html file for use with documentation
	@cd docs/coverage; mv index.html coverage.html


# help: style                          - perform pep8 check
style:
	@$(STYLE_PEP8_CMD)


# help: style.fix                      - perform check with autopep8 fixes
style.fix:
	@# If there are no files to fix then autopep8 typically returns an error
	@# because it did not get passed any files to work on. Use xargs -r to
	@# avoid this problem.
	@$(STYLE_PEP8_CMD) -q  | xargs -r autopep8 -i --max-line-length=$(STYLE_MAX_LINE_LENGTH)


# help: docs                           - generate project documentation
docs: coverage
	@cd docs; rm -rf api/aioprometheus*.rst api/modules.rst _build/*
	@cd docs; sphinx-apidoc -o ./api ../aioprometheus
	@cd docs; make html
	@cd docs; cp -R coverage _build/html/.


# help: dist                           - create a wheel based distribution package
dist:
	@$(PYTHON) setup.py bdist_wheel


# help: sdist                          - create a source distribution package
sdist:
	@$(PYTHON) setup.py sdist


# Keep these lines at the end of the file to retain nice help
# output formatting.
# help: