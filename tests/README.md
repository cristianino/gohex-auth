# Tests

Este directorio contiene todas las pruebas organizadas según la arquitectura hexagonal y tipos de testing.

## Estructura

```
tests/
├── unit/          # Tests unitarios - prueban componentes individuales
├── integration/   # Tests de integración - prueban la interacción entre componentes
├── e2e/          # Tests end-to-end - prueban el flujo completo de la aplicación
└── README.md     # Este archivo
```

## Tipos de Tests

### Tests Unitarios (`unit/`)
- Prueban funciones y métodos individuales de forma aislada
- Uso de mocks para dependencias externas
- Ejecución rápida
- Ejemplo: `app_test.go` - prueba la creación del router

### Tests de Integración (`integration/`)
- Prueban la interacción entre múltiples componentes
- Pueden usar bases de datos en memoria o servicios mockeados
- Ejemplo: `api_test.go` - prueba endpoints HTTP usando httptest

### Tests End-to-End (`e2e/`)
- Prueban el flujo completo de la aplicación
- Pueden requerir servicios externos reales
- Más lentos pero más cercanos al uso real
- Ejemplo: `api_e2e_test.go` - prueba con servidor HTTP real

## Comandos

```bash
# Ejecutar todos los tests
go test ./tests/... -v

# Ejecutar solo tests unitarios
go test ./tests/unit -v

# Ejecutar solo tests de integración
go test ./tests/integration -v

# Ejecutar solo tests e2e
go test ./tests/e2e -v

# Ejecutar tests con coverage
go test ./tests/... -v -cover
```

## Convenciones

- Cada archivo de test debe terminar en `_test.go`
- Los tests deben seguir el patrón `TestNombreFuncion`
- Usar `gin.SetMode(gin.TestMode)` en tests con Gin
- Los tests de integración deben usar `httptest` para evitar levantar servidores reales
- Los tests e2e pueden usar servidores reales pero deben hacer cleanup
