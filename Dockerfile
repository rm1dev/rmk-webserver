FROM webdevops/php-apache:8.1

# persistent dependencies
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
# Ghostscript is required for rendering PDF previews
		ghostscript \
	; \
	rm -rf /var/lib/apt/lists/*

# set timezone to Tehran
RUN apt-get update && apt-get install -y tzdata
ENV TZ=Asia/Tehran
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN echo "date.timezone = 'Asia/Tehran'" > $(php -i | grep '^Scan this dir for additional .ini files =' | cut -d' ' -f9)timezone.ini

# Install Source Guardian
RUN PHPVERSION=$(php -v | head -n1 | cut -d' ' -f2 | cut -d. -f1-2) \
    && mkdir -p /tmp/sourceguardian \
    && cd /tmp/sourceguardian \
    && curl -o "ixed.${PHPVERSION}.lin" -Os "https://www.sourceguardian.com/loaders/download.php?d=linux-$(uname -m)&ixed=ixed.${PHPVERSION}.lin" \
    && cp "ixed.${PHPVERSION}.lin" "$(php -i | grep '^extension_dir =' | cut -d' ' -f3)/ixed.${PHPVERSION}.lin" \
    && docker-php-ext-enable "ixed.${PHPVERSION}.lin" \
    && rm -rf /tmp/sourceguardian

EXPOSE 80 443
