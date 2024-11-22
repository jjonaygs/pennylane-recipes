import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

document.addEventListener("turbo:frame-loading", () => {
    const spinner = document.getElementById("loading-spinner");
    if (spinner) {
      spinner.style.display = "block";
    }
  
    const footer = document.querySelector(".fixed-bottom");
    if (footer) {
      footer.style.display = "none";
    }
  });
  
  document.addEventListener("turbo:frame-loaded", () => {
    const spinner = document.getElementById("loading-spinner");
    if (spinner) {
      spinner.style.display = "none";
    }
  
    const footer = document.querySelector(".fixed-bottom");
    if (footer) {
      footer.style.display = "block";
    }
  });
  