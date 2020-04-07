FROM store/intersystems/iris-community:2020.1.0.215.0

RUN mkdir -p /tmp/deps \
 && wget -q https://pm.community.intersystems.com/packages/zpm/latest/installer -O /tmp/deps/zpm.xml \
 && iris start $ISC_PACKAGE_INSTANCENAME quietly \
 && iris session $ISC_PACKAGE_INSTANCENAME -U %SYS "##class(%SYSTEM.OBJ).Load(\"/tmp/deps/zpm.xml\",\"ck\")" \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly \
 && rm -rf /tmp/deps

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]