function [value]=vf_gh_gcp(def,head)
%VF_GH_GCP  Returns value for virtual field GCP

% get baz
tmp=head(def.baz,:);

% who's (un)defined?
nv=size(head,2);
good=(isreal(tmp) & ~isnan(tmp) & ~isinf(tmp) & tmp~=def.undef.ntype);

% default to all undef
value(nv,1)=def.undef.ntype;

if(any(good))
    value(good,1)=mod(tmp+180,360);
end

end
