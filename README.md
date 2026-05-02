# Gold Rate App

A professional Flutter application for displaying live gold rates with advanced features like hidden premium prices, configurable data sources, and a modern, user-friendly interface.

## Features

- **Live Gold Rates**: Displays prices for 24K, 22K, 18K, and Silver.
- **Premium Price Hiding**: Toggle visibility of premium prices with a single tap.
- **Modern UI**: Clean, modern design with smooth animations and gradients.
- **Configurable**: Customize company name, URL, font size, and data source elements.
- **Offline Support**: Save settings locally using `shared_preferences`.
- **Responsive Design**: Adapts to different screen sizes.
- **Smooth Navigation**: Bottom navigation with custom gradient backgrounds and smooth transitions.

## Getting Started

### Prerequisites

- Flutter SDK (v3.11.5 or higher)
- Android Studio or VS Code
- Dart SDK (v3.11.5 or higher)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd gold_price
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

## Usage

### Main Screen

The main screen displays the gold and silver rates fetched from the configured URL.
- **Top Grid**: Shows live market rates.
- **Premium Block**: Contains premium prices that can be hidden or shown.
- **Bottom Grid**: Shows computed prices (100g, 50g, 20g, 10g, 5g, 1g).

### Settings Screen

Access the settings by tapping the "Settings" icon in the bottom navigation.

#### General Configuration
- **Company Name**: Set the name displayed on the app bar.
- **Font Size**: Adjust the font size for the rate displays.

#### Data Sources
- **Target URL**: The URL from which to fetch the gold data.
- **Gold JS Element**: The JavaScript element name for gold prices.
- **Silver JS Element**: The JavaScript element name for silver prices.

### Models

The application uses `MainViewModel` to manage the state and logic.

#### Key Methods
- `parseHtmlString()`: Parses the HTML content from the URL.
- `calculatePrices()`: Calculates derived prices from the fetched data.
- `fetchGoldPrice()`, `fetchSilverPrice()`: Fetches prices using `webview_all`.
- `saveSettings()`, `loadSettings()`: Manages persistent storage of settings.
- `toggleVisibility()`: Toggles the visibility of premium prices.

## Technologies Used

- **Flutter**: UI framework
- **webview_all**: Webview integration for data scraping
- **shared_preferences**: Local data persistence
- **provider**: State management
- **url_launcher**: URL launching

## Folder Structure

```
gold_price/
├── lib/
│   ├── main.dart           # Application entry point
│   ├── models/
│   │   └── main_view_model.dart  # State management and business logic
│   ├── pages/
│   │   ├── home_page.dart      # Main screen displaying gold rates
│   │   └── settings_page.dart  # Settings configuration screen
│   └── widgets/
│       └── modern_row.dart     # Custom widget for displaying rate rows
├── assets/
│   ├── icon.png            # Application icon
├── pubspec.yaml            # Project dependencies and configuration
├── README.md               # Project documentation
```

## Customization

To customize the app for a different website:

1. Update `lib/models/main_view_model.dart`:
   - Change `companyName` in `MainViewModel` constructor.
   - Update `goldUrl`, `silverUrl`, `goldElement`, and `silverElement` in `loadSettings` or directly in the class.
   - Adjust `parseHtmlString()` if the HTML structure of the new website is different.

2. Update `pubspec.yaml`:
   - Change `name` and `description` if needed.
   - Add or update any dependencies.

3. Update `lib/main.dart`:
   - Change `appTitle` in `GoldRateApp` if needed.

4. Update `lib/widgets/modern_row.dart`:
   - Modify the styling or layout of the rate rows if desired.

## Development

### Adding New Features

1. Create a new page in `lib/pages/`.
2. Create a new model or widget in `lib/models/` or `lib/widgets/`.
3. Add the new page to the `_pages` list in `MainScreen`.
4. Update navigation in `_buildBottomNavigationBar()` if needed.
5. Add any new dependencies to `pubspec.yaml`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
