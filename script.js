const flashlight = document.querySelector('.flashlight');

document.addEventListener('mousemove', (e) => {
    // Update the position of the flashlight to follow the cursor
    flashlight.style.left = `${e.clientX}px`;
    flashlight.style.top = `${e.clientY}px`;

    // Create a mask to hide everything outside the flashlight
    const mask = document.createElement('div');
    mask.style.position = 'absolute';
    mask.style.width = '100vw';
    mask.style.height = '100vh';
    mask.style.backgroundColor = 'black';
    mask.style.clipPath = `circle(30px at ${e.clientX}px ${e.clientY}px)`;
    mask.style.pointerEvents = 'none';

    // Remove the previous mask and add the new one
    const oldMask = document.querySelector('.mask');
    if (oldMask) oldMask.remove();
    mask.classList.add('mask');
    document.body.appendChild(mask);
});
