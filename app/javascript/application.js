// Entry point for the build script in your package.json

import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "./channels"

Rails.start()
ActiveStorage.start()

import 'bootstrap'

// CSS
// import 'scss/site'

// JS
import './js/site'

// Images
// const images = require.context('./images', true)
// const imagePath = (name) => images(name, true)

import { singleFileUpload, multipleFileUpload } from './fileUpload'

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('input[type=file]').forEach(fileInput => {
    if (fileInput.multiple) {
      multipleFileUpload(fileInput)
    } else {
      singleFileUpload(fileInput)
    }
  })
})
