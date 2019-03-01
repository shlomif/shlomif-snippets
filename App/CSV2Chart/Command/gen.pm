package App::CSV2Chart::Command::gen;

use strict;
use warnings;

# Based on https://metacpan.org/source/JMCNAMARA/Excel-Writer-XLSX-0.99/examples/chart_scatter.pl by John McNamara - thanks!
#
# Modified by Shlomi Fish ( https://www.shlomifish.org/ ) while putting the
# changes under https://creativecommons.org/choose/zero/ .

#######################################################################
#
# A demo of a Scatter chart in Excel::Writer::XLSX. Other subtypes are
# also supported such as markers_only (the default), straight_with_markers,
# straight, smooth_with_markers and smooth. See the main documentation for
# more details.
#
# reverse ('(c)'), March 2011, John McNamara, jmcnamara@cpan.org
#

use App::CSV2Chart -command;
use Excel::Writer::XLSX;
use Text::CSV;

sub opt_spec
{
    return ( [ "output|o=s", "Output path" ] );
}

sub execute
{
    my ( $self, $opt, $args ) = @_;

    my $workbook  = Excel::Writer::XLSX->new( $opt->{output} );
    my $worksheet = $workbook->add_worksheet();
    my $bold      = $workbook->add_format( bold => 1 );

    my $csv = Text::CSV->new;
    my $fh  = \*STDIN;

    my $headings = $csv->getline($fh);

    # Add the worksheet data that the charts will refer to.
    my $data = [ map { [] } @$headings ];
    while ( my $row = $csv->getline($fh) )
    {
        while ( my ( $i, $v ) = each @$row )
        {
            push @{ $data->[$i] }, $v;
        }
    }

    $worksheet->write( 'A1', $headings, $bold );
    $worksheet->write( 'A2', $data );

    my $w = @$headings;
    my $h = @{ $data->[0] };

    # Create a new chart object. In this case an embedded chart.
    my $chart1 = $workbook->add_chart( type => 'scatter', embedded => 1 );

    # Configure second series. Note alternative use of array ref to define
    # ranges: [ $sheetname, $row_start, $row_end, $col_start, $col_end ].
    $chart1->add_series(
        name       => '=Sheet1!$B$1',
        categories => [ 'Sheet1', 1, 1 + $h, 0, 0 ],
        values     => [ 'Sheet1', 1, 1 + $h, 1, 1 ],
    );

    # Add a chart title and some axis labels.
    $chart1->set_title( name => 'Results of sample analysis' );
    $chart1->set_x_axis( name => 'Test number' );
    $chart1->set_y_axis( name => 'Sample length (mm)' );

    # Set an Excel chart style. Blue colors with white outline and shadow.
    $chart1->set_style(11);

    # Insert the chart into the worksheet (with an offset).
    $worksheet->insert_chart( 'D2', $chart1, 25, 10 );

    if (0)
    {
        #
        # Create a scatter chart sub-type with straight lines and markers.
        #
        my $chart2 = $workbook->add_chart(
            type     => 'scatter',
            embedded => 1,
            subtype  => 'straight_with_markers'
        );

        # Configure the first series.
        $chart2->add_series(
            name       => '=Sheet1!$B$1',
            categories => '=Sheet1!$A$2:$A$7',
            values     => '=Sheet1!$B$2:$B$7',
        );

        # Configure second series.
        $chart2->add_series(
            name       => '=Sheet1!$C$1',
            categories => [ 'Sheet1', 1, 6, 0, 0 ],
            values     => [ 'Sheet1', 1, 6, 2, 2 ],
        );

        # Add a chart title and some axis labels.
        $chart2->set_title( name => 'Straight line with markers' );
        $chart2->set_x_axis( name => 'Test number' );
        $chart2->set_y_axis( name => 'Sample length (mm)' );

        # Set an Excel chart style. Blue colors with white outline and shadow.
        $chart2->set_style(12);

        # Insert the chart into the worksheet (with an offset).
        $worksheet->insert_chart( 'D18', $chart2, 25, 11 );

        #
        # Create a scatter chart sub-type with straight lines and no markers.
        #
        my $chart3 = $workbook->add_chart(
            type     => 'scatter',
            embedded => 1,
            subtype  => 'straight'
        );

        # Configure the first series.
        $chart3->add_series(
            name       => '=Sheet1!$B$1',
            categories => '=Sheet1!$A$2:$A$7',
            values     => '=Sheet1!$B$2:$B$7',
        );

        # Configure second series.
        $chart3->add_series(
            name       => '=Sheet1!$C$1',
            categories => [ 'Sheet1', 1, 6, 0, 0 ],
            values     => [ 'Sheet1', 1, 6, 2, 2 ],
        );

        # Add a chart title and some axis labels.
        $chart3->set_title( name => 'Straight line' );
        $chart3->set_x_axis( name => 'Test number' );
        $chart3->set_y_axis( name => 'Sample length (mm)' );

        # Set an Excel chart style. Blue colors with white outline and shadow.
        $chart3->set_style(13);

        # Insert the chart into the worksheet (with an offset).
        $worksheet->insert_chart( 'D34', $chart3, 25, 11 );

        #
        # Create a scatter chart sub-type with smooth lines and markers.
        #
        my $chart4 = $workbook->add_chart(
            type     => 'scatter',
            embedded => 1,
            subtype  => 'smooth_with_markers'
        );

        # Configure the first series.
        $chart4->add_series(
            name       => '=Sheet1!$B$1',
            categories => '=Sheet1!$A$2:$A$7',
            values     => '=Sheet1!$B$2:$B$7',
        );

        # Configure second series.
        $chart4->add_series(
            name       => '=Sheet1!$C$1',
            categories => [ 'Sheet1', 1, 6, 0, 0 ],
            values     => [ 'Sheet1', 1, 6, 2, 2 ],
        );

        # Add a chart title and some axis labels.
        $chart4->set_title( name => 'Smooth line with markers' );
        $chart4->set_x_axis( name => 'Test number' );
        $chart4->set_y_axis( name => 'Sample length (mm)' );

        # Set an Excel chart style. Blue colors with white outline and shadow.
        $chart4->set_style(14);

        # Insert the chart into the worksheet (with an offset).
        $worksheet->insert_chart( 'D51', $chart4, 25, 11 );

        #
        # Create a scatter chart sub-type with smooth lines and no markers.
        #
        my $chart5 = $workbook->add_chart(
            type     => 'scatter',
            embedded => 1,
            subtype  => 'smooth'
        );

        # Configure the first series.
        $chart5->add_series(
            name       => '=Sheet1!$B$1',
            categories => '=Sheet1!$A$2:$A$7',
            values     => '=Sheet1!$B$2:$B$7',
        );

        # Configure second series.
        $chart5->add_series(
            name       => '=Sheet1!$C$1',
            categories => [ 'Sheet1', 1, 6, 0, 0 ],
            values     => [ 'Sheet1', 1, 6, 2, 2 ],
        );

        # Add a chart title and some axis labels.
        $chart5->set_title( name => 'Smooth line' );
        $chart5->set_x_axis( name => 'Test number' );
        $chart5->set_y_axis( name => 'Sample length (mm)' );

        # Set an Excel chart style. Blue colors with white outline and shadow.
        $chart5->set_style(15);

        # Insert the chart into the worksheet (with an offset).
        $worksheet->insert_chart( 'D66', $chart5, 25, 11 );

    }

    $workbook->close();

    return;
}

1;

__END__
