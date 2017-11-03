use strict;
use Data::Dumper;
use JSON;
use open ':std', ':encoding(UTF-8)';
use HTML::Entities;

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

     print "## $post->{data}->{title}\n";
     print  decode_entities($post->{data}->{media_embed}->{content}) . "\n\n\n\n"
}


my $base_name = $post->{data}->{permalink};
$base_name =~ s/.*\/(\w+)\//$1/;
#print $base_name . "\n";
#`curl -s -o images/$base_name.jpg "$url"`;
}


}
