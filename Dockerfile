FROM pweyck/sw6-base:latest

WORKDIR /app

RUN wget --quiet http://releases.shopware.com/sw6/install_6.2_next.tar.zst -O install.tar.zst \
 && zstd -df --rm install.tar.zst \
 && tar -xf install.tar \
 && rm install.tar \
 && chown www-data:www-data -R .

EXPOSE 8000

ENTRYPOINT [ "/bin/entrypoint.sh" ]