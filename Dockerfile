FROM quay.io/keycloak/keycloak:23.0.5 as builder
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=postgres
ENV KC_FEATURES=token-exchange,admin-fine-grained-authz
COPY keycloak-metrics-spi-4.0.0.jar /opt/keycloak/providers/keycloak-metrics-spi.jar
COPY keycloak-kafka-1.1.5-jar-with-dependencies.jar /opt/keycloak/providers/keycloak-kafka.jar

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:23.0.5
COPY --from=builder /opt/keycloak/ /opt/keycloak/
COPY keycloak-metrics-spi-3.0.0.jar /opt/keycloak/providers/keycloak-metrics-spi.jar

# change these values to point to a running postgres instance
ENV KC_DB=postgres
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
