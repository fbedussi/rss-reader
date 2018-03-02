function setMaxHeightInPx(articleExcerpt, articleExcerptInner) {
    articleExcerpt.style.maxHeight = articleExcerptInner.clientHeight + 'px';
}

function getInnerElements(article) {
    return {
        articleExcerpt: article.querySelector('.article-excerpt'),
        articleExcerptInner: article.querySelector('.article-excerptInner'),
    }
}

function openExcerpt(domId) {
    const article = document.querySelector('#' + domId);

    if (!article) {
        return;
    }
    
    const {articleExcerpt, articleExcerptInner} = getInnerElements(article);

    setMaxHeightInPx(articleExcerpt, articleExcerptInner);

    articleExcerpt.addEventListener('transitionend', function setAutoHeight() {
        articleExcerpt.style.maxHeight = 'auto';
        articleExcerpt.removeEventListener('transitionend', setAutoHeight);
    });
}

function closeExcerpt(domId, originalMaxHeight) {
    const article = document.querySelector('#' + domId);

    if (!article) {
        return;
    }
    
    const {articleExcerpt, articleExcerptInner} = getInnerElements(article);

    setMaxHeightInPx(articleExcerpt, articleExcerptInner);
    articleExcerpt.style.maxHeight = originalMaxHeight + 'em';

    articleExcerpt.addEventListener('transitionend', function resetMaxHeight() {
        articleExcerpt.style.maxHeight = '';
        articleExcerpt.removeEventListener('transitionend', resetMaxHeight);
        article.querySelector('a').focus();
    });
}

export function toggleExcerpt({domId, toOpen, originalMaxHeight}) {
    if (toOpen) {
        openExcerpt(domId);
    } else {
        closeExcerpt(domId, originalMaxHeight);
    }
}

export function initReadMoreButtons() {
    setTimeout(function() {
        document.querySelectorAll('.article').forEach((article) => {
            const {articleExcerpt, articleExcerptInner} = getInnerElements(article);
    
            if (articleExcerptInner.clientHeight > articleExcerpt.clientHeight) {
                article.querySelector('.readMoreButton').style.visibility = 'visible';
                article.querySelector('.readMoreButton').style.opacity = 1;
            }
        });
    }, 10);
}