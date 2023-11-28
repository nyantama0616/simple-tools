require_relative "./ArgManager"

describe "Test ArgManager" do
  def test_handled_args(argv, expected)
    args = PaperFind::ArgManager.arranged_args(argv)
    expect(args).to eq expected
  end

  it "オプションがないときは正しく処理できるか" do
    argv = ["10.1002/dev.20059"]
    expected = {
      origin: ["10.1002/dev.20059"],
      cite: false
    }
    test_handled_args(argv, expected)    
  end

  it "--citeを正しく処理できるか1" do
    argv = ["--cite", "10.1002/dev.20059"]
    expected = {
      origin: ["10.1002/dev.20059"],
      cite: true
    }
    test_handled_args(argv, expected)    
  end
  
  it "--citeを正しく処理できるか2" do
    argv = ["10.1002/dev.20059", "--cite"]
    expected = {
      origin: ["10.1002/dev.20059"],
      cite: true
    }
    test_handled_args(argv, expected)    
  end
end
