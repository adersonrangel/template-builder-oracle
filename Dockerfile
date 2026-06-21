# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:10.0

ENV TZ=CET

COPY ./instantclient_23_26 /opt/oracle/instantclient_23_26

RUN apt-get update && \
    apt-get install -y --no-install-recommends libaio1t64 libnsl2 && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/lib/x86_64-linux-gnu/libaio.so.1t64 /usr/lib/x86_64-linux-gnu/libaio.so.1

RUN echo /opt/oracle/instantclient_23_26 > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

ENV ORACLE_HOME=/opt/oracle/instantclient_23_26
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_23_26
ENV PATH=/opt/oracle/instantclient_23_26:$PATH
ENV TNS_ADMIN=/opt/oracle/instantclient_23_26/network/admin
