# 🏥 spring-petclinic-opentelemetry

[![Observability-Ready](https://img.shields.io/badge/observability-ready-brightgreen?style=flat-square)](https://opentelemetry.io/)
[![OpenTelemetry](https://img.shields.io/badge/opentelemetry-instrumented-blueviolet?style=flat-square&logo=opentelemetry)](https://opentelemetry.io/)
[![New Relic](https://img.shields.io/badge/telemetry-sent%20to%20New%20Relic-00c8ff?style=flat-square&logo=new-relic)](https://newrelic.com/)

A pre-instrumented version of [Spring Petclinic](https://github.com/spring-projects/spring-petclinic), wired with **OpenTelemetry Zero-Code Instrumentation** — ready for real-time distributed tracing, logs, and metrics.

> 🧪 Run it, hit it with traffic, and watch your telemetry stream into New Relic, Datadog, or any OTLP-compatible backend.

---

## 🌟 Features

- ✅ **Zero-code instrumentation** using OpenTelemetry Java Agent
- ✅ Integrated with **New Relic OTLP ingest**
- 🐳 Docker Compose with:
  - Spring Boot App
  - MySQL / PostgreSQL
  - k6 Load Generator
- 📦 Minimal config — get started in <2 minutes

---

## 🚀 Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/avecenabasuni/spring-petclinic-opentelemetry.git
cd spring-petclinic-opentelemetry
```

### 2. Set your New Relic Ingest Key (or other OTLP-compatible backend)

Create a `.env` file:

```env
NEW_RELIC_LICENSE_KEY=your_key_here
```

### 3. Run the app

```bash
docker-compose up --build
```

This will:

- Start the Petclinic app
- Inject the OpenTelemetry Java agent
- Generate load via `k6` after boot
- Ship traces, logs, and metrics to your observability backend

---

## 📊 Observability Preview

Example of what you'll see in New Relic (or other backend):

- 🔍 **Distributed traces** across controller → service → JDBC
- 📈 JVM metrics: memory, GC, threads
- 📜 Auto-captured logs correlated with spans
- 🌐 Service map & dependency graph

---

## 🔧 Tech Stack

- Java 17
- Spring Boot
- OpenTelemetry Java Agent
- Docker / Docker Compose
- MySQL + PostgreSQL (you can choose one)
- k6 (Grafana) for load testing
- OTLP → New Relic (default, but you can swap it)

---

## 🧠 References

- [OpenTelemetry Java Agent](https://github.com/open-telemetry/opentelemetry-java-instrumentation)
- [Spring Petclinic](https://github.com/spring-projects/spring-petclinic)
- [New Relic OTLP Setup Guide](https://docs.newrelic.com/docs/opentelemetry/setup/)
- [k6 Load Testing](https://k6.io/)

---

## 🙌 Credits

Originally based on Spring’s legendary demo app. Instrumented and adapted by [@avecenabasuni](https://github.com/avecenabasuni) for modern observability.

---

## ✨ License

[Apache 2.0](LICENSE)
