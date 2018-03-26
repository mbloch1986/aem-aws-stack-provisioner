version ?= 2.4.9

ci: clean lint package

clean:
	rm -rf .tmp Puppetfile.lock Gemfile.lock modules stage

deps: Gemfile.lock Puppetfile.lock

Puppetfile.lock: Puppetfile Gemfile.lock
	bundle exec r10k puppetfile install --verbose --moduledir modules

Gemfile.lock: Gemfile
	bundle install

validate: Gemfile.lock
	bundle exec puppet parser validate manifests/*.pp
	bundle exec puppet epp validate templates/*.epp templates/**/*.epp

lint: validate Gemfile.lock
	bundle exec puppet-lint \
		--fail-on-warnings \
		--no-140chars-check \
		--no-autoloader_layout-check \
		--no-documentation-check \
		--no-only_variable_string-check \
		--no-selector_inside_resource-check \
		--no-variable_scope-check \
		--log-format "%{path} (%{check}) L%{line} %{message}" \
		manifests/*.pp
	shellcheck files/*/*.sh

package: deps
	rm -rf stage
	mkdir -p stage
	tar \
		--exclude='.git*' \
		--exclude='.tmp*' \
		--exclude='stage*' \
		--exclude='.idea*' \
		--exclude='.DS_Store*' \
		--exclude='examples' \
		-cvf \
		stage/aem-aws-stack-provisioner-$(version).tar ./
	gzip stage/aem-aws-stack-provisioner-$(version).tar

tools:
	gem install bundler

.PHONY: ci clean deps lint package validate tools
