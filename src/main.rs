use tch::Tensor;

fn main() -> opencv::Result<()> {
    let t = Tensor::from_slice(&[3, 1, 4, 1, 5]);
    let t = t * 2;
    t.print();
    Ok(())
}

