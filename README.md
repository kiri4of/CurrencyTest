# Currency Test Task
Using **Swift** and **UIKit**, this straightforward iOS application allows you to mark exchange rates as favorites, retrieve currency exchange rates using **GraphQL**, and enable basic offline functionality. The structure, architecture, dependencies, offline caching, and building instructions for the program are all explained in this README.

---

## Table of Contents
1. [Overview and Purpose](#1-overview-and-purpose)  
2. [Architecture and Key Components](#2-architecture-and-key-components)  
   - [2.1 MVVM Pattern](#21-mvvm-pattern)  
   - [2.2 Managers](#22-managers)  
   - [2.3 CollectionAdapter](#23-collectionadapter)  
   - [2.4 Offline Caching (UserDefaults)](#24-offline-caching-userdefaults)  
3. [Technical Setup](#3-technical-setup)  
   - [3.1 API Keys and Keychain](#31-api-keys-and-keychain)  
   - [3.2 GraphQL Network (Apollo)](#32-graphql-network-apollo)  
   - [3.3 SnapKit for UI Layout](#33-snapkit-for-ui-layout)  
4. [Building and Running](#4-building-and-running)  
   - [4.1 Prerequisites](#41-prerequisites)  
   - [4.2 Steps](#42-steps)  
5. [Common Issues and Troubleshooting](#5-common-issues-and-troubleshooting)  
   - [5.1 API Key Not Found](#51-api-key-not-found)  
   - [5.2 Favorites Not Updating](#52-favorites-not-updating)  
   - [5.3 No Internet / Offline Mode](#53-no-internet--offline-mode)  

---

## 1. Overview and Purpose
**TestTask** is an iOS demo project showcasing:
* **Fetch** currency exchange rates from a **GraphQL** endpoint (SWOP API).  
* **Mark** specific rates as *favorites*, saved locally in `UserDefaults`.  
* **Offline support** by caching the most recent fetched data.  
* **Secure** API key storage using Keychain.

It contains two main screens:
1. **Currency Rates** screen: displays current exchange rates with toggleable favorites.  
2. **Favorites** screen: shows only the rates marked as favorites. (The favorite button is hidden here, so user cannot remove items in this screen.)

---

## 2. Architecture and Key Components

### 2.1. MVVM Pattern
- **Models**  
  - `CurrencyRateModel` (date, baseCurrency, quoteCurrency, quote).  
- **ViewModels**  
  - `CurrencyViewModel`: Fetches data from `GraphQLNetwork`, handles toggling favorites, notifies UI.  
  - `FavoritesViewModel`: Observes changes from `FavoritesManager` and updates the favorites list.
- **Views / Controllers**  
  - `CurrencyViewController` and `FavoritesViewController` each host a collection view, managed by a `CollectionAdapter`.  
  - `CurrencyView` / `FavoritesView`: Simple container views using **SnapKit** for layout.

### 2.2. Managers
- **`FavoritesManager`**  
  - Stores and serializes favorite rates in `UserDefaults`.  
  - Posts a `.favoritesDidChange` notification whenever favorites are updated, allowing the UI to refresh immediately.
- **`OfflineCacheManager`**  
  - Caches fetched exchange rates in `UserDefaults` for offline usage.  
  - Used by `GraphQLNetwork` to load previously saved rates if a network request fails.
- **`KeychainManager`**  
  - Demonstrates secure storage of sensitive information (like API keys) in the iOS Keychain.  
  - `Configuration` uses it to retrieve the SWOP API key at runtime.
- **`GraphQLNetwork`**  
  - Performs Apollo GraphQL queries, stores successful fetch results in `OfflineCacheManager`.  
  - On failure, returns cached data if available.

### 2.3. CollectionAdapter
A reusable class to handle:
* **Compositional Layout** for the collection view.  
* **Diffable Data Source** for smooth UI updates.  
* **Star (favorite) button** handling via a closure (`onFavoriteTapped`).

When `items` changes, `applySnapshot()` is called to refresh the UI without manual reloads.

### 2.4. Offline Caching (UserDefaults)
* **OfflineCacheManager** encodes an array of `[CurrencyRateModel]` in JSON and saves it under a key (e.g., `"CachedCurrencyRates"`).  

---

## 3. Technical Setup

### 3.1. API Keys and Keychain
* **KeychainManager**: 
  - Provides methods `save(key:value:)`, `load(key:)`, `delete(key:)`.  
  - The SWOP API key is stored under the `"SWOPAPIKey"` account in the Keychain.
* **Configuration**: 
  - Reads baseURL from `Configuration.plist`.
  - Optionally references `KeychainManager.shared.load(key: "SWOPAPIKey")`.

### 3.2. GraphQL Network (Apollo)
* **Apollo** is integrated to query SWOP.  
* The `GraphQLNetwork` class fetches `LatestEuroQuery`, caches rates on success, or loads from `OfflineCacheManager` on failure.

### 3.3. SnapKit for UI Layout
All screens (e.g., `CurrencyView`, `FavoritesView`) use **SnapKit** for concise constraints:
```swift
titleLabel.snp.makeConstraints { make in
    make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
    make.leading.trailing.equalToSuperview().inset(16)
}
```
## 4. Building and Running

### 4.1. Prerequisites
* **Xcode 13+** (recommended)
* **iOS 14+** deployment target
* **Swift 5.5+**

### 4.2. Steps

1. **Clone the repository:**
   ```bash
   git clone <https://github.com/kiri4of/CurrencyTest>
  
2. **Open the project in Xcode:**
  * Swift Package Manager will automatically fetch dependencies (e.g., Apollo, SnapKit).

3. **Configure your API key:** 
  * Save your SWOP API key to the Keychain. For example, in your AppDelegate, you might include:
  ```swift 
  KeychainManager.shared.save(key: "SWOPAPIKey", value: "<YOUR_KEY>")
  ```
4. **Run the app:**
  * Select a simulator or a real device, then press Cmd + R.

5. **Test offline mode**: 
  * After a successful fetch, disable your network (simulate no internet).
  * Confirm the app loads data from the offline cache via OfflineCacheManager.

## 5. Common Issues and Troubleshooting

### 5.1. Missing API Key in Keychain
Cause: The key "SWOPAPIKey" was not saved before running the app, or there's an issue with retrieving it.

Solution:
Ensure you call:
```swift 
KeychainManager.shared.save(key: "SWOPAPIKey", value: "YOUR_KEY")
```
(e.g., in AppDelegate during the first launch) and verify that your Configuration.plist is set up correctly.

### 5.2. Favorites Not Updating
 **Cause**: The UI does not refresh if the NotificationCenter subscription or the FavoritesViewModel update mechanism is not set up correctly.

 **Solution**: 
 1. Confirm that `FavoritesManager.shared.toggleFavorite(_:)` posts the notification: 
 ```swift 
 NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
```
2. Verify that `FavoritesViewModel` observes `.favoritesDidChange` and calls `loadFavorites()` to update its `favorites` array.

### 5.3. No Internet / Offline Mode Not Working
**Cause**: If the user never completed a successful network fetch, no cached data exists in OfflineCacheManager. Alternatively, caching might have failed.

 **Solution**: 
 1. Ensure that `GraphQLNetwork.fetchLatestEuroRates` calls `OfflineCacheManager.shared.saveRates(...)` upon a successful response.
2. Confirm that `OfflineCacheManager.shared.loadRates()` is used to return cached data when a network error occurs.
3. Note: The offline mode will only work if there has been at least one successful data fetch.

## Architecture and Design Choices

### Architecture Overview
This project is built using the **Model-View-ViewModel (MVVM)** architectural pattern. MVVM was selected for several reasons:

* **Separation of Concerns:** MVVM produces cleaner, easier-to-maintain code by clearly separating the UI rendering (Views/ViewControllers) from the business logic and data management (ViewModels).
* **Scalability and Reusability:** Code reuse and functionality growth are made easy by the distinct split. The main screen and the favorites screen are two examples of screens that might use the same ViewModel logic.
* **Responsive UI:** By facilitating data binding using callbacks or observers (such as closures or NotificationCenter), MVVM makes guarantee that the user interface (UI) immediately adjusts in response to changes in the underlying data.

### Offline Caching and Data Storage
In this example, JSON-encoded currency rate data is stored using **UserDefaults** to provide offline caching. For small datasets, this method is straightforward and efficient. Its robustness and scalability are constrained, though.

> **Note:**  
> The goal of this project is to demonstrate a contemporary iOS application that makes use of **MVVM**, **GraphQL** through **Apollo**, and offline caching using **UserDefaults**. To guarantee improved performance, data integrity, and scalability in production settings, it is advised to take into account more reliable storage options like **Core Data** or **SQLite** in addition to sophisticated error handling techniques.
