#versão mais leve
FROM nginx:alpine

#remover o arquivo padrão
RUN rm /etc/nginx/conf.d/default.conf

# copiar o arquivo de configuração
COPY default.conf /etc/nginx/conf.d/

# copiar o conteúdo da aplicação
COPY . /usr/share/nginx/html

#expor a porta 80
EXPOSE 80
