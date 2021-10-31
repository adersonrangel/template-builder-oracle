# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:3.1
ENV TZ=CET
COPY ./instantclient_21_1 /opt/oracle/instantclient_21_1/
RUN  apt-get update && \ 
     apt-get install -y libaio1
RUN  sh -c "echo /opt/oracle/instantclient_21_1 > \
      /etc/ld.so.conf.d/oracle-instantclient.conf" && \
    ldconfig
RUN export TNS_ADMIN=/opt/oracle/instantclient_21_1/network/admin
