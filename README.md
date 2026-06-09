# Dynamic Profile

## Architecture

The app uses MVVM.
- `NetworkServiceProtocol` decouples the ViewModel from URLSession, enabling fast unit tests with a mock implementation.

## Dynamic Field Ordering

The `/config` endpoint returns an ordered array of field name strings. The app maps these to a `ProfileFieldType` enum using `compactMap`, which silently drops any unknown strings without crashing.

```
["name", "photo", "gender", "about", "school"]
    → [.name, .photo, .gender, .about, .school]
```

The `ProfileFieldView` renders fields using a switch over this ordered array. If you want to add a new field type it is extensiable by just adding a new enum case and a corresponding switch case.

The view will drop any fields that might be on the config but not on a particular user.

## Concurrency

Both API calls (`/users` and `/config`) are fired concurrently using `async let`. The ViewModel suspends until both complete, then processes the results together.

## Libraries
- `AsyncImage` handles remote image loading with built-in loading and failure states.

## Testing

Tests are written using Swift Testing (`@Test`, `#expect`). The `MockNetworkService` conforms to `NetworkServiceProtocol` and uses simple error properties.

Coverage includes:
- Unknown config strings are silently dropped
- Empty user array produces an empty state, not a crash
- Network failure produces a typed error state
- `nextUser()` advances correctly through the list
- `nextUser()` is a no-op when already on the last user
- `hasNextUser` accurately reflects remaining profiles

## Demo
<img width="295" height="640" alt="Simulator Screen Recording - iPhone 17 Pro - 2026-06-09 at 15 32 38" src="https://github.com/user-attachments/assets/1051c682-a578-408a-802a-42e6865ffdba" />

## Notes
- The API base URL uses `http`, not `https`. An App Transport Security exception for the S3 domain is included in `Info.plist`.
