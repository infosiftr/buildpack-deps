#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM alpine:3.16

# explicitly install base image package updates from Alpine
RUN set -eux; \
	apk add --no-cache \
		'musl=1.2.3-r2' \
		'musl-utils=1.2.3-r2' \
		'libssl1.1=1.1.1t-r0' \
		'libcrypto1.1=1.1.1t-r0' \
	;
