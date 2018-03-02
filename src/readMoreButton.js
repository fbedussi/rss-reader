function setMaxHeightInPx(articleExcerpt, articleExcerptInner) {
    articleExcerpt.style.maxHeight = articleExcerptInner.clientHeight + 'px';
}

function openExcerpt({domId, originalMaxHeight}) {
    const article = document.querySelector('#' + domId);

    if (!article) {
        return;
    }
    
    const articleExcerpt = article.querySelector('.article-excerpt');
    const articleExcerptInner = article.querySelector('.article-excerptInner');
    const readMorebutton = article.querySelector('.readMoreButton');
    const readLessbutton = article.querySelector('.readLessButton');

    setMaxHeightInPx(articleExcerpt, articleExcerptInner);
    article.classList.add('is-open');

    articleExcerpt.addEventListener('transitionend', function setAutoHeight() {
        articleExcerpt.style.maxHeight = 'auto';
        articleExcerpt.removeEventListener('transitionend', setAutoHeight);

        readLessButton.addEventListener('click', function setOriginalMaxHeight() {
            setMaxHeightInPx(articleExcerpt, articleExcerptInner);
            articleExcerpt.style.maxHeight = originalMaxHeight + 'em';
            article.classList.remove('is-open');
            readLessButton.removeEventListener('click', setOriginalMaxHeight);
        });

        articleExcerpt.addEventListener('transitionend', function resetMaxHeight() {
            articleExcerpt.style.maxHeight = '';
            articleExcerpt.removeEventListener('transitionend', resetMaxHeight);
        });
    })
}

export default openExcerpt;