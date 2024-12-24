if (!picked_up) {
    // Apply gravity
    yvel += grav;
    
    // Apply friction only to horizontal movement
    xvel *= 0.95;
    
    x += xvel;
    y += yvel;
    
    // Optional: Add ground collision
    if (y > room_height) {
        y = room_height;
        yvel = 0;
    }
} 