use strict;
use Data::Dumper;
use JSON;
use open ':std', ':encoding(UTF-8)';
use HTML::Entities;
use URI::Encode qw(uri_encode uri_decode);

my $image_count = 0;



my $sub = shift;

get_posts($sub);
	

exit;




sub get_posts{
my ($sub) = @_; 
#my $posts = $reddit->get_links(subreddit=>"$sub", limit=>10,);

my $json = `curl -s -H "User-Agent: potatoe:lovetruth.life:0.0.1 (by /u/bwigfield)" -X GET -L https://www.reddit.com/r/$sub/.json?limit=100`;
my $data = decode_json($json);
#print Dumper $data;

print "# $sub\n\n";
my @posts = @{$data->{data}->{children}} ;
foreach my $post (@posts){
#print Dumper $post->{data};
my $source_url = $post->{data}->{preview}->{images}[0]->{source}->{url};
my $url = $post->{data}->{preview}->{images}[0]->{resolutions}[2]->{url};
$url =~ s/&amp;/&/g;
#print $post->{data}->{preview}->{images}[0]->{resolutions}[2]->{url} . "\n";
#print $url . "\n";

if ($post->{data}->{url} =~ m/jpg|gif|gifv|png$/){
    #print $post->{data}->{url} . "\n";
}

if ( scalar keys $post->{data}->{media_embed}  gt 0){
#print Dumper $post->{data}->{media_embed} ;

     print "## $post->{data}->{title}\n" . "headline scores at " . score_headline($post->{data}->{title}) . "\n";
     print  decode_entities($post->{data}->{media_embed}->{content}) . "\n\n\n\n"
}


my $base_name = $post->{data}->{permalink};
$base_name =~ s/.*\/(\w+)\//$1/;
#print $base_name . "\n";
#`curl -s -o images/$base_name.jpg "$url"`;
}


}



sub score_headline {
my ($headline) = @_;
#$headline = uri_encode($headline);
$headline =~ s/ /+/g;
$headline =~ /'//g;
return ` curl -s 'http://www.aminstitute.com/cgi-bin/headline.cgi' -H 'Cookie: __utma=130967839.629129005.1509669307.1509669307.1509669307.1; __utmc=130967839; __utmz=130967839.1509669307.1.1.utmccn=(referral)|utmcsr=google.com|utmcct=/|utmcmd=referral; headlinecheck=2; __utmb=130967839' -H 'Origin: http://www.aminstitute.com' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: http://www.aminstitute.com/headline/index.htm' -H 'Connection: keep-alive' --data 'text=$headline&category=Arts+%26+Entertainment&Submit2=Submit+For+Analysis' --compressed |  grep '<div align="center"><font size="7"><b><font size="5">' | awk -F'>' '{print \$5}' | awk -F'<' '{print \$1}' | tr % ' '`;
}
