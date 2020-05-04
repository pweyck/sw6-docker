FROM pweyck/sw6-base:latest

WORKDIR /app

RUN wget --quiet http://releases.shopware.com/sw6/install_6.2_next.tar.xz -O install.tar.xz \
 && tar -xf install.tar.xz \
 && rm install.tar.xz \
 && chown www-data:www-data -R .

EXPOSE 8000

ENTRYPOINT [ "/bin/entrypoint.sh" ]