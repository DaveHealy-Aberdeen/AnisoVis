% Load MRI scan
load('mri','D'); D=smooth3(squeeze(D));
% Make iso-surface (Mesh) of skin
FV=isosurface(D,1);
% Calculate Iso-Normals of the surface
N=isonormals(D,FV.vertices);
L=sqrt(N(:,1).^2+N(:,2).^2+N(:,3).^2)+eps;
N(:,1)=N(:,1)./L; N(:,2)=N(:,2)./L; N(:,3)=N(:,3)./L;
% Display the iso-surface
figure, patch(FV,'facecolor',[1 0 0],'edgecolor','none'); view(3);camlight
% Invert Face rotation
FV.faces=[FV.faces(:,3) FV.faces(:,2) FV.faces(:,1)];
%
% Make a material structure
material(1).type='newmtl';
material(1).data='skin';
material(2).type='Ka';
material(2).data=[0.8 0.4 0.4];
material(3).type='Kd';
material(3).data=[0.8 0.4 0.4];
material(4).type='Ks';
material(4).data=[1 1 1];
material(5).type='illum';
material(5).data=2;
material(6).type='Ns';
material(6).data=27;
%
% Make OBJ structure
clear OBJ
OBJ.vertices = FV.vertices;
OBJ.vertices_normal = N;
OBJ.material = material;
OBJ.objects(1).type='g';
OBJ.objects(1).data='skin';
OBJ.objects(2).type='usemtl';
OBJ.objects(2).data='skin';
OBJ.objects(3).type='f';
OBJ.objects(3).data.vertices=FV.faces;
OBJ.objects(3).data.normal=FV.faces;

write_wobj(OBJ,'skinMRI.obj');
