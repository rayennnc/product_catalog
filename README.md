# Product Catalog

A Flutter product catalog app built using the free [DummyJSON Products API](https://dummyjson.com/docs/products)

## Requirements

* Flutter SDK with Dart 3.5.4 or later
* An Android, iOS, web, or desktop device/emulator

## Run the App

```
flutter pub get
flutter run
```

To run the static analysis and tests:

```
flutter analyze
flutter test
```

## Features

* Product list displaying title, thumbnail, and price
* Infinite scrolling pagination using the API's `skip` parameter
* Product detail screen with description, price, rating, and image gallery
* Loading, error with retry, empty, and success states
* Debounced product search

## Architecture

The project is organized into two main layers:

### `lib/data/`

* `product.dart` — Product and API response models, including JSON parsing
* `product_service.dart` — Handles HTTP requests to the DummyJSON API

### `lib/ui/`

* `product_list_screen.dart` — Manages the product list, pagination, search, and list states
* `product_detail_screen.dart` — Handles product detail loading and display states

The UI layer communicates with the API through the service layer instead of making HTTP requests directly. This keeps API communication and JSON parsing separate from the widgets and makes the data layer easier to test or replace.

## Search Decision

Search is implemented using debounced client-side filtering.

I chose this approach because it was simple to implement for this assessment. The app searches the titles of products that have already been loaded.

The trade-off is that the search cannot find products that have not been loaded yet. The DummyJSON API also provides a search endpoint, which could be used instead if searching across all products were required.

## Known Limitations / TODOs

* Search does not use the DummyJSON search endpoint, so it only searches products that have already been loaded.
* Pull-to-refresh is not implemented.
* Image loading placeholders and image error handling could be improved.
* A focused unit test for model parsing and a widget test covering the product states could be added.

## AI Usage

Before starting this assignment, I built a separate practice project using the Rick and Morty API to rehearse the core patterns used in this assessment, including JSON parsing, pagination, loading/error/empty/success states, and debounced search. AI was used during this practice phase as a learning and review tool to explain concepts, review code, and help identify bugs.

During this assignment, I also used AI for conceptual questions, debugging guidance, code review, and to generate or suggest parts of the implementation. I reviewed, adapted, and integrated the relevant suggestions into the project rather than using the generated output as an unreviewed solution.

I reviewed the final implementation, tested the application, and made the final decisions regarding the project structure, features, API integration, search approach, and scope.