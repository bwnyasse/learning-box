FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
COPY assets/sa-key* ./
COPY assets/us_stocks.json ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart run build_runner build --delete-conflicting-outputs
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
ENV FETCHER_SERVICE_IN_DOCKER=true

COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
COPY --from=build /app/sa-key* /
COPY --from=build /app/us_stocks.json /

# Start server.
EXPOSE 8080
CMD ["/app/bin/server"]