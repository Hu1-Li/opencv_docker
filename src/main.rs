use opencv::prelude::*;
use opencv::videoio::{VideoCapture, CAP_PROP_FRAME_COUNT};

fn main() -> opencv::Result<()> {
    let cap = VideoCapture::from_file("sample-mp4-file-small.mp4", 0)?;
    let frame_count = cap.get(CAP_PROP_FRAME_COUNT)?;
    println!("Number of frames: {}", frame_count);
    Ok(())
}

