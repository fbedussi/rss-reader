import debounce from './debounce';

var isButtonVisible = false;
const threshold = 1000;
const buttonSelector = '.backToTopButton';

function displayNone() {
    this.style.display = 'none';
    this.removeEventListener('transitionend', displayNone);    
}

function hideButton(button) {
    button.style.opacity = 0;        
    button.removeEventListener('transitionend', displayNone);
    button.addEventListener('transitionend', displayNone);
}

function showButton(button) {
    button.style.display = 'inline-block';
    setTimeout(() => {
        button.style.opacity = 1;
    }, 0);    
}

function manageBackToTopButton() {
    if (document.scrollingElement.scrollTop > threshold && !isButtonVisible) {
        showButton(document.querySelector(buttonSelector));
        isButtonVisible = true;
    } else if (document.scrollingElement.scrollTop < threshold && isButtonVisible) {
        hideButton(document.querySelector(buttonSelector));
        isButtonVisible = false;        
    }
}

export default function initBackToTopButton() {
    window.addEventListener('scroll', debounce(manageBackToTopButton, 70));
} 
