/// Base URL of your backend, e.g. `http://1.2.3.4:3001`.
/// For iPhone, `localhost` points to the phone itself, not your Mac/server.
const String serverUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://92.38.48.187:3001',
);
