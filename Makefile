
# You should have this configuraiton file with restrictive permissions.
include Makefile.conf

export AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY)
export AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_KEY)
export S3_USE_SIGV4=$(S3_SIGV4)
export PASSPHRASE=$(GPG_PASSPHRASE)

VERSION := 0.1.0

.PHONY: all
all: help

.PHONY: s3
s3: $(DUPLICITY_BIN)
	$(DUPLICITY_BIN) $(SRC_DIR) s3://$(BCP_HOST)/$(BCP_DIR)

.PHONY: update
update:
	wget -O Makefile https://raw.githubusercontent.com/theranger/duplicity-make/master/Makefile

.PHONY: update-conf
update-conf:
	wget --backups=1 https://raw.githubusercontent.com/theranger/duplicity-make/master/Makefile.conf

.PHONY: update-all
update-all: update update-conf

.PHONY: help
help:
	@echo "\nRunning duplicity-make version: $(VERSION)\n"
	@echo "This is a collection of backup targets to be used with Duplicity backup tool."
	@echo "To run them, create a cron script in /etc/cron.daily with a command something like:\n"
	@echo "\tmake -C /opt/backup SRC=<source_directory> DST=<bucket_name> s3\n\n"
	@echo "Note, that this script does not support parallel make.\n"
