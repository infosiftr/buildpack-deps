#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM alpine:3.15

# explicitly install base image package updates from Alpine
RUN set -eux; \
	apk add --no-cache \
		'libssl1.1=1.1.1t-r1' \
		'libcrypto1.1=1.1.1t-r1' \
	;
