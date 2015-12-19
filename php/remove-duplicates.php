<?
function remove_duplicates($arr)
{
    $dups = array();

    $results = array();

    foreach ($arr as $elem)
    {
        if (! array_key_exists($elem, $dups))
        {
            $dups[$elem] = 1;
            array_push($results, $elem);
        }
    }

    return $results;
}

$v = array(10,5,5,9,10,8);
print var_dump($v);
echo "Foo\n";
$r = remove_duplicates($v);
echo var_dump($r), "\n";
?>
