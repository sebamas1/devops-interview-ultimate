## ✨ Quick Start in `Docker`

> Start the app in Docker

```bash
$ docker-compose up --build 
```

The React UI starts on port `3000` and expects an API server on port `8000` (saved in configuration).

<br />


**API Server URL** - `src/config/constant.js` 

```javascript
const config = {
    ...
    API_SERVER: 'http://localhost:8000/api/'  // <-- The magic line
};
```

**Backend projectL** 
```
https://github.com/sleakops/test-app-backend

```

[React Node JS Datta Able](https://appseed.us/product/react-node-js-datta-able) - Provided by [CodedThemes](https://codedthemes.com/) and **AppSeed [App Generator](https://appseed.us/app-generator)**.



