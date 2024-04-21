# hide_out

## Environment setup
- run `make setup` in the project root directory

## Upload on Google Play Store
- place `upload-keystore.jks` in `android/app` directory
- place `key.properties` in `android` directory  
- for more details, see `Security/upload-keystore.jks` on Notion

## Hosting
1. switch configDev or configProd based on environment at web/index.html
2. `fvm flutter build web`
3. `firebase use dev` or `firebase use prod`
4. `firebase deploy --only hosting`

