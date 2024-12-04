require "pyramid_sort"

RSpec.describe PyramidSort::Sorter do
  it "correctly sorts an array" do
    array = [4, 10, 3, 5, 1]
    sorted_array = PyramidSort::Sorter.heap_sort(array)
    expect(sorted_array).to eq([1, 3, 4, 5, 10])
  end

  it "handles an already sorted array" do
    array = [1, 2, 3, 4, 5]
    sorted_array = PyramidSort::Sorter.heap_sort(array)
    expect(sorted_array).to eq([1, 2, 3, 4, 5])
  end

  it "handles a reverse-sorted array" do
    array = [5, 4, 3, 2, 1]
    sorted_array = PyramidSort::Sorter.heap_sort(array)
    expect(sorted_array).to eq([1, 2, 3, 4, 5])
  end

  it "handles an empty array" do
    array = []
    sorted_array = PyramidSort::Sorter.heap_sort(array)
    expect(sorted_array).to eq([])
  end

  it "handles an array with one element" do
    array = [42]
    sorted_array = PyramidSort::Sorter.heap_sort(array)
    expect(sorted_array).to eq([42])
  end

  it "handles an array with duplicate elements" do
    array = [5, 3, 5, 1, 3, 2]
    sorted_array = PyramidSort::Sorter.heap_sort(array)
    expect(sorted_array).to eq([1, 2, 3, 3, 5, 5])
  end

  it "handles an array with negative numbers" do
    array = [3, -1, -10, 5, 0]
    sorted_array = PyramidSort::Sorter.heap_sort(array)
    expect(sorted_array).to eq([-10, -1, 0, 3, 5])
  end

  it "handles an array with floating point numbers" do
    array = [3.5, 1.2, 4.8, 2.1, 0.5]
    sorted_array = PyramidSort::Sorter.heap_sort(array)
    expect(sorted_array).to eq([0.5, 1.2, 2.1, 3.5, 4.8])
  end

  it "raises an error for non-numeric array elements" do
    array = [1, "a", 3]
    expect { PyramidSort::Sorter.heap_sort(array) }.to raise_error(ArgumentError)
  end

  it "raises an error for non-array input" do
    input = "not an array"
    expect { PyramidSort::Sorter.heap_sort(input) }.to raise_error(ArgumentError)
  end
end
