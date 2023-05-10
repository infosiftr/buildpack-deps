#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM alpine:3.17

# explicitly install base image package updates from Alpine
RUN set -eux; \
	apk add --no-cache \
		'libcrypto3=3.0.8-r0' \
		'libssl3=3.0.8-r0' \
	;
