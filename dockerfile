# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
ENV TZ=CET
COPY ./instantclient_19_8 /opt/oracle/instantclient_19_8/
RUN  apt-get update && \ 
     apt-get install -y libaio1
RUN  sh -c "echo /opt/oracle/instantclient_19_8 > \
      /etc/ld.so.conf.d/oracle-instantclient.conf" && \
    ldconfig
RUN export TNS_ADMIN=/opt/oracle/instantclient_19_8/network/admin
