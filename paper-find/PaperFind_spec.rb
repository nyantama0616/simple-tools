require_relative "./PaperFind"

describe "Test Paper Find" do
  def test_cited_format(doi, expected)
    paper_find = PaperFind::PaperFind.new(doi)
    expect(paper_find.cited_format).to eq expected
  end

  it "引用時用のフォーマットは意図した通りになってるか１" do
    doi = "10.1037/amp0000794"
    expect = "Yeager, D. and Dweck, C.: What can be learned from growth mindset controversies?, American Psychologist, Vol.75, No.9, pp.1269-1284 (2020)."
    test_cited_format(doi, expect)
  end
  
  it "引用時用のフォーマットは意図した通りになってるか２" do
    doi = "10.2307/1421351"
    expect = "Attneave, F. and Olson, R.: Pitch as a Medium: A New Approach to Psychophysical Scaling, The American Journal of Psychology, Vol.84, No.2, pp.147 (1971)."
    test_cited_format(doi, expect)
  end
  
  it "引用時用のフォーマットは意図した通りになってるか３" do
    doi = "10.2307/1416385"
    expect = "Hevner, K.: The Affective Value of Pitch and Tempo in Music, The American Journal of Psychology, Vol.49, No.4, pp.621 (1937)."
    test_cited_format(doi, expect)
  end
end
