# Kakuro Permutations
#
# Copyrighted By Shlomi Fish ( http://www.shlomifish.org/ ), 2008
#
# Licensed under the MIT/X11 License:
# http://www.opensource.org/licenses/mit-license.php

class KakuroPermutations

    def initialize()
        @min_digit = 1
        @max_digit = 9
    end

    def get_permutations_from(start, sum, num_places)
        if num_places == 1
            if (sum >= start) && (sum <= @max_digit)
                return [[sum]]
            else
                return []
            end
        end

        results = []
        (start .. [@max_digit, sum].min).each do |first|
            results +=
                get_permutations_from(
                    first+1, sum-first, num_places-1
                ).map {|rest| [first, *rest]}
        end
        return results
    end

    def get_permutations(sum, num_places)
        return get_permutations_from(@min_digit, sum, num_places)
    end
end

describe "Kakuro" do
    before do
        @perm = KakuroPermutations.new
    end

    it "should give [1,2] for 3" do
        @perm.get_permutations(3,2).should eql([[1,2]])
    end

    it "should give [1,2,4] for 7" do
        @perm.get_permutations(7,3).should eql([[1,2,4]])
    end

    it "should give [1,2,3,4,5] for 15 over 5" do
        @perm.get_permutations(15,5).should eql([[1,2,3,4,5]])
    end

    it "should give correct results for 25 over 5" do
        @perm.get_permutations(25,5).should eql([
            [1,2,5,8,9],
            [1,2,6,7,9],
            [1,3,4,8,9],
            [1,3,5,7,9],
            [1,3,6,7,8],
            [1,4,5,6,9],
            [1,4,5,7,8],
            [2,3,4,7,9],
            [2,3,5,6,9],
            [2,3,5,7,8],
            [2,4,5,6,8],
            [3,4,5,6,7],
        ])
    end
end
