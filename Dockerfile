FROM metabase/metabase:v0.33.0

LABEL maintainer="Fedorov Andrey"

COPY /plugins/ /plugins
