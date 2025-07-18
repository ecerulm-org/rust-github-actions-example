const VERSION: &'static str = env!("CARGO_PKG_VERSION");
fn main() {
    println!("rust-github-actions-example v{VERSION}");
}

#[test]
fn test1() {
    let result = 2 + 2;
    assert_eq!(result, 4);
}
